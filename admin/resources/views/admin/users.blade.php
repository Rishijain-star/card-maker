@extends('admin.layouts.app')

@section('content')
<div class="stats-grid filter-chips">
    <div class="stat-card">
        <h3>All Users</h3>
        <div class="value">{{ $counts['total'] }}</div>
    </div>
    <div class="stat-card">
        <h3>Paid</h3>
        <div class="value" style="color:var(--green)">{{ $counts['paid'] }}</div>
    </div>
    <div class="stat-card">
        <h3>Unpaid</h3>
        <div class="value" style="color:var(--orange)">{{ $counts['unpaid'] }}</div>
    </div>
    <div class="stat-card">
        <h3>New</h3>
        <div class="value" style="color:var(--blue)">{{ $counts['new'] }}</div>
    </div>
</div>

<div class="panel">
    <div class="panel-head">
        <h3>All Platform Users</h3>
        <span>Paid · Unpaid · New — everyone who registered</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Orders</th>
                <th>Payment</th>
                <th>Joined</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($users as $user)
                <tr>
                    <td>#{{ $user['id'] }}</td>
                    <td><strong>{{ $user['name'] }}</strong></td>
                    <td>{{ $user['email'] }}</td>
                    <td>{{ $user['phone'] }}</td>
                    <td>{{ $user['orders_count'] }}</td>
                    <td>
                        @php
                            $badge = match ($user['payment_status']) {
                                'Paid' => 'badge-green',
                                'Unpaid' => 'badge-orange',
                                'New' => 'badge-blue',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ $user['payment_status'] }}</span>
                    </td>
                    <td>{{ $user['joined'] }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
