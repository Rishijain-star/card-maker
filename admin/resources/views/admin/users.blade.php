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
        <span>Paid · Unpaid · New — everyone registered from the mobile app</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Orders</th>
                <th>Saved Cards</th>
                <th>Payment</th>
                <th>Joined</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($users as $user)
                <tr>
                    <td>#{{ $user->id }}</td>
                    <td>
                        <a href="{{ route('admin.users.show', $user->id) }}" style="color:var(--blue); font-weight:700;">
                            {{ $user->name ?: 'User #' . $user->id }}
                        </a>
                    </td>
                    <td>{{ $user->email }}</td>
                    <td><strong>{{ $user->product_orders_count }}</strong></td>
                    <td>
                        <strong>{{ $user->saved_cards_count }}</strong> / {{ number_format($user->getSaveLimit()) }}
                        <div style="font-size:11px; color:var(--muted)">({{ number_format($user->getRemainingCardCapacity()) }} left)</div>
                    </td>
                    <td>
                        @php
                            $status = $user->getPaymentStatus();
                            $badge = match ($status) {
                                'Paid' => 'badge-green',
                                'Unpaid' => 'badge-orange',
                                'New' => 'badge-blue',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ $status }}</span>
                        @if ($user->isPremiumActive())
                            <div style="font-size:10px; font-weight:600; color:var(--green); margin-top:2px;">{{ strtoupper($user->premium_plan) }}</div>
                        @endif
                    </td>
                    <td>{{ $user->created_at ? $user->created_at->format('d M Y') : '—' }}</td>
                    <td>
                        <a href="{{ route('admin.users.show', $user->id) }}" style="font-weight:600; color:var(--blue); font-size:12px;">
                            View &rarr;
                        </a>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="8" style="text-align:center; padding: 24px; color:var(--muted)">
                        No registered users found yet.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>
@endsection
