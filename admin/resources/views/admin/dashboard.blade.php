@extends('admin.layouts.app')

@section('content')
<div class="stats-grid">
    @foreach ($stats as $stat)
        <div class="stat-card">
            <h3>{{ $stat['title'] }}</h3>
            <div class="value">{{ $stat['value'] }}</div>
            <div class="hint">{{ $stat['hint'] }}</div>
        </div>
    @endforeach
</div>

<div class="panel">
    <div class="panel-head">
        <h3>Recent Orders</h3>
        <span>{{ $orderStats['successful'] }} successful orders</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>User</th>
                <th>Product</th>
                <th>Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            @foreach (array_slice($orders, 0, 5) as $order)
                <tr>
                    <td>{{ $order['order_id'] }}</td>
                    <td>{{ $order['user'] }}</td>
                    <td>{{ $order['product'] }}</td>
                    <td>₹{{ number_format($order['amount']) }}</td>
                    <td>
                        @php
                            $badge = match ($order['status']) {
                                'Success' => 'badge-green',
                                'Pending' => 'badge-orange',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ $order['status'] }}</span>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
